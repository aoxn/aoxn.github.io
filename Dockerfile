FROM node:alpine
COPY . /Hexo
WORKDIR /Hexo
#RUN node --version && npm version && exit 1

RUN npm update && \
	npm install hexo --save && \
	npm install hexo-cli -g && \
	npm install
RUN hexo clean && hexo g

ENTRYPOINT ["hexo","s"]
