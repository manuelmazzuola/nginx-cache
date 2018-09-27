FROM nginx:mainline-alpine

ENV CACHE_TTL '1y'
ENV MAX_CACHE_SIZE '10g'

VOLUME [ "/var/cache/nginx" ]

COPY nginx.conf /etc/nginx/nginx.conf

RUN sed -i "s/\"\$http_x_forwarded_for\"';/\"\$http_x_forwarded_for\" \$request_time';/g" /etc/nginx/nginx.conf
RUN ln -sf /dev/stdout /var/log/nginx/cache_access.log

CMD /bin/sh -c "envsubst '\$CACHE_TTL \$MAX_CACHE_SIZE' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf && nginx -g 'daemon off;'"
