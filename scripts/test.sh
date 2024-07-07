#!/bin/bash

echo -e "\n2** tests:"
echo 200 is $(curl -ik -o /dev/null -s -w "%{response_code}\n" "https://localhost")
echo WP fresh install: 200 is $(curl -ik -o /dev/null -s -w "%{response_code}\n" "https://localhost/wp-admin/install.php")
echo 200 is $(curl -ik -o /dev/null -s -w "%{response_code}\n" "https://localhost/healthz")
echo 200 is $(curl -ik -o /dev/null -s -w "%{response_code}\n" "https://localhost/robots.txt")

echo -e "\n3** tests:"
echo 301 is $(curl -ik -o /dev/null -s -w "%{response_code}\n" "https://localhost/.well-known/security.txt")

echo -e "\n4** tests:"
echo 403 is $(curl -ik -o /dev/null -s -w "%{response_code}\n" "https://localhost/exec()")
echo 403 is $(curl -ik -o /dev/null -s -w "%{response_code}\n" "https://localhost/<script>alert(1)</script>")
echo 403 is $(curl -ik -o /dev/null -s -w "%{response_code}\n" "https://localhost/../../etc/passwd%00")
