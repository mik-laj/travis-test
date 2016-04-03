#!/bin/bash -e

jekyll build
# htmlproofer ./_site

if [ "$TRAVIS_BRANCH" == "production" ]; then 
	echo 'Publish'
	cd _site
	git config --global user.email "travis@example.com" > /dev/null
	git config --global user.name "Travis-CI" > /dev/null
	git init > /dev/null
	git add . > /dev/null
	git checkout -b ${TRAVIS_REPO_BRANCH} &> /dev/null
	git commit -m "Update site" > /dev/null
	# Register a deploy server
	# echo '' > .git/config
	# echo '[remote "origin"]' >> .git/config
	# echo -n '	url = http://' >> .git/config
	# echo -n $GH_TOKEN >> .git/config
	# echo -n '@github.com/' >> .git/config
	# echo -n $TRAVIS_REPO_SLUG >> .git/config
	# echo '.git' >> .git/config
	# echo 'fetch = +refs/heads/*:refs/remotes/origin/*' >> .git/config

	# Do deploy
	git push -fq https://${GH_TOKEN}@github.com/${TRAVIS_REPO_SLUG}.git ${TRAVIS_REPO_BRANCH} &> /dev/null
	cd ..

	cd $TRAVIS_REPO_COPY_DIR
	for d in */ ; do
		echo "Upload: $d"
		pushd "$d"
		echo $PWD
		git init
		git add .
		git checkout -b "$(basename $d)" 
		git commit -m "Upload sample code"
		git push -fq https://${GH_TOKEN}@github.com/${TRAVIS_REPO_COPY_SLUG}.git $(basename $d) &> /dev/null
		popd
	done

fi
