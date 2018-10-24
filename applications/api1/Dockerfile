FROM keymetrics/pm2:10-alpine

MAINTAINER Team Origin

# Create the app directory
RUN mkdir -p /var/www/app
WORKDIR /var/www/app

RUN apk add --no-cache \
  python \
  make 
RUN pm2 install pm2-logrotate

# Install app
COPY .npmrc /var/www/app
COPY . /var/www/app
RUN ls
RUN npm install --only=production

CMD ["npm", "run", "start"]