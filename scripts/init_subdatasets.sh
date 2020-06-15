#!/bin/bash

# this script is meant to be used with 'datalad run'

for i in "$@"
do
	case ${i} in
		--lang=*)
		LANGUAGE="${i#*=}"
		echo "LANGUAGE = [${LANGUAGE}]"
		;;
		*)
		>&2 echo Unknown option [${i}]
		exit 1
		;;
	esac
done

if [ -z "${LANGUAGE}" ]
then
	LANGUAGE="de en es fr it"
fi


REPO_NAME=https://voice-prod-bundler-ee1969a6ce8178826482b88e843c335139bd3fb4.s3.amazonaws.com/cv-corpus-4-2019-12-10/

for lang in ${LANGUAGE}
do
	datalad create -d . ${lang}/
	dataset=${REPO_NAME}${lang}.tar.gz
	cd ${lang}/
	echo "${REPO_NAME}${lang}.tar.gz ${lang}.tar.gz" | git-annex addurl --raw --batch --with-files
	cd ..
done
