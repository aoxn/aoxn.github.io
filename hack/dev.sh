
# install nodejs
if ! which node >/dev/null;
then
	brew install node
fi

# install npm
if ! which npm >/dev/null;
then
	brew install npm
fi

#  http://nodejs.cn/learn/update-all-the-nodejs-dependencies-to-their-latest-version
if ! which ncu >/dev/null;
then
	npm install -g npm-check-updates
fi

ncu -u 
npm install; npm update

# install nodejs


