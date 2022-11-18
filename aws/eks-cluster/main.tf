terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">4.35"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_iam_role" "eks_role" {
  name = "iam_role_eks_cluster_${var.resource_id_suffix}"

  path = "/"

  assume_role_policy = file("./policies/role_policy_eks.json")
}

resource "aws_iam_role" "nodes_role" {
  name = "iam_role_eks_nodes_${var.resource_id_suffix}"

  path = "/"

  assume_role_policy = file("./policies/role_policy_nodes.json")
}

resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_container_registry_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_iam_role_policy_attachment" "cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_iam_role_policy_attachment" "nodes_container_registry_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_role.name
}

resource "aws_vpc" "test" {
  cidr_block = "10.91.0.0/16"

  tags = {
    Name = "vpc_${var.resource_id_suffix}"
  }
}

resource "aws_subnet" "snet_a" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.91.1.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name = "snet_${var.resource_id_suffix}_a"
  }
}

resource "aws_subnet" "snet_b" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "10.91.2.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name = "snet_${var.resource_id_suffix}_b"
  }
}

resource "aws_eks_cluster" "test" {
  name     = "eks_${var.resource_id_suffix}"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = [aws_subnet.snet_a.id, aws_subnet.snet_b.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy_attachment,
    aws_iam_role_policy_attachment.cluster_container_registry_attachment,
    aws_iam_role.eks_role,
  ]
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.test.name
  node_group_name = "eks_nodes_${var.resource_id_suffix}"
  node_role_arn   = aws_iam_role.nodes_role.arn
  subnet_ids      = [aws_subnet.snet_a.id, aws_subnet.snet_b.id]
  instance_types  = ["t2.small"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policy_attachment,
    aws_iam_role_policy_attachment.cni_policy_attachment,
    aws_iam_role_policy_attachment.nodes_container_registry_attachment,
    aws_iam_role.nodes_role
  ]
}
