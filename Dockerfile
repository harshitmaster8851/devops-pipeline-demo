# Dockerfile - serve static site using nginx
FROM nginx:alpine

# remove default nginx content
RUN rm -rf /usr/share/nginx/html/*

# copy website files
COPY website/ /usr/share/nginx/html/

# expose the port nginx serves in container
EXPOSE 8080

# configure nginx to listen on 8080 instead of 80
# create a small nginx conf override
RUN mkdir -p /etc/nginx/conf.d
COPY nginx-site.conf /etc/nginx/conf.d/default.conf

# run nginx (default)
CMD ["nginx", "-g", "daemon off;"]
