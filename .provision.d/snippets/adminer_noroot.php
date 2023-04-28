// https://sourceforge.net/p/adminer/discussion/960418/thread/75537d20/#91a5
<?php
function adminer_object() {

    class AdminerNoRoot extends Adminer {

        function login($login, $password) {
            return ($login != 'root');
        }

    }

    return new AdminerNoRoot;
}
include "./adminer.php";
