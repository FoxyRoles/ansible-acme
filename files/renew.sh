#!/bin/bash

# The remaining life on our certificate below which we should renew (7 days).
RENEW=7

function run_acme {
    $HOME/acme_tiny.py --account-key $HOME/account.key --csr $HOME/$1.csr --acme-dir $HOME/challenges > $HOME/$1.crt || exit
    cat $HOME/$1.crt $HOME/intermediate.crt > $HOME/$1.chained.crt
}

if [ ! -f $HOME/rsa.crt ]; then
    run_acme rsa
elif ! openssl x509 -checkend $[ 86400 * $RENEW ] -noout -in $HOME/rsa.crt; then
    run_acme rsa
fi

sudo service nginx reload
