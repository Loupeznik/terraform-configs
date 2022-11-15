if ($null -eq $args[0]) {
    $pass = '""'
} else {
    $pass = $args[0]
}

ssh-keygen -b 4096 -f $HOME/.ssh/tf_tests_id_rsa -N $pass
