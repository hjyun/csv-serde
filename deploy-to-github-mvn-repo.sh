#!/bin/bash

if [ x"$MVNREPO_HOME" == "x" ]; then
	echo "MVNREPO_HOME was not set, aborts"
	exit 1
fi

rm -rf releases
rm -rf snapshots

mvn deploy

if [ -d "releases" ]; then
	cp -fvr releases/* $MVNREPO_HOME/releases

	MSG="deploying following files\n"
	for f in $(find snapshots -name "*.jar"); do
		FN=$(basename $f)
		MSG="$MSG\n$FN"
	done
	(cd $MVNREPO_HOME && git add . ; git commit -am "$(echo -e "$MSG")")
fi

if [ -d "snapshots" ]; then
	cp -fvr snapshots/* $MVNREPO_HOME/snapshots

	MSG="deploying following files\n"
	for f in $(find snapshots -name "*.jar"); do
		FN=$(basename $f)
		MSG="$MSG\n$FN"
	done
	(cd $MVNREPO_HOME && git add . ; git commit -am "$(echo -e "$MSG")")
fi

(cd $MVNREPO_HOME && git push)

echo "DEPLOYING DONE!"

