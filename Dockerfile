FROM nginx:latest
RUN echo "<h1>Hello from Custom Nginx Image</h1>" > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
