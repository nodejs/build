#!/bin/bash

set -e
secretsdir=$1

if ! [ -d $secretsdir ] || ! [ -d ${secretsdir}/.git ]; then
  echo "Usage: makesecrets.sh <path/to/secrets/repo>"
  exit 1
fi

function bork {
  echo "Something borked, perhaps you got your passphrase wrong? ..."
  exit 1
}

#if ! [ -f dhparam.pem ]; then
#  echo "Generating 4096 dhparam, this may take some time ..."
#  openssl dhparam -out dhparam.pem 4096
#fi

read -p "Enter GPG passphrase: " -s gpgpass

echo ""

gpgcmd="gpg --batch -q -q --passphrase '${gpgpass}'"

echo "Extracting dhparam.pem..."
bash -c "$gpgcmd" < ${secretsdir}/build/release/dhparam.pem 1> ./dhparam.pem 2> /dev/null || bork

echo "Extracting nodejs.key..."
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_nodejs.org.key 1> ./nodejs.key 2> /dev/null || bork

echo "Extracting iojs.key..."
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_iojs.org.key 1> ./iojs.key 2> /dev/null || bork

echo "Extracting nodejs_chained.crt..."
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_nodejs.org.crt 1> ./nodejs_chained.crt 2> /dev/null || bork
echo "" >> ./nodejs_chained.crt
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_nodejs.org-COMODORSADomainValidationSecureServerCA.crt 1>> ./nodejs_chained.crt 2> /dev/null || bork
echo "" >> ./nodejs_chained.crt
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_nodejs.org-COMODORSAAddTrustCA.crt 1>> ./nodejs_chained.crt 2> /dev/null || bork
echo "" >> ./nodejs_chained.crt
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_nodejs.org-AddTrustExternalCARoot.crt 1>> ./nodejs_chained.crt 2> /dev/null || bork
echo "" >> ./nodejs_chained.crt

echo "Extracting iojs_chained.crt..."
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_iojs.org.crt 1> ./iojs_chained.crt 2> /dev/null || bork
echo "" >> ./iojs_chained.crt
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_iojs.org-COMODORSADomainValidationSecureServerCA.crt 1>> ./iojs_chained.crt 2> /dev/null || bork
echo "" >> ./iojs_chained.crt
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_iojs.org-COMODORSAAddTrustCA.crt 1>> ./iojs_chained.crt 2> /dev/null || bork
echo "" >> ./iojs_chained.crt
bash -c "$gpgcmd" < ${secretsdir}/build/release/star_iojs.org-AddTrustExternalCARoot.crt 1>> ./iojs_chained.crt 2> /dev/null || bork
echo "" >> ./nodejs_chained.crt

echo "Extracting staging_id_rsa_public.key..."
bash -c "$gpgcmd" < ${secretsdir}/build/release/staging_id_rsa_public.key 1>> ./staging_id_rsa_public.key 2> /dev/null || bork
echo "" >> ./staging_id_rsa_public.key


