# Dockerfile (serve static site with nginx)
FROM nginx:alpine

# remove default site
RUN rm -rf /usr/share/nginx/html/*

# copy site files
COPY website/ /usr/share/nginx/html/

# expose container port
EXPOSE 8080

# configure nginx to listen on 8080
COPY nginx-site.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
