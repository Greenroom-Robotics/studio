# Build stage
FROM node:16 as build
WORKDIR /src
COPY . ./

RUN corepack enable
RUN yarn install --immutable

RUN yarn run web:build:prod

# Release stage
FROM caddy:2.5.2-alpine
LABEL org.opencontainers.image.source https://github.com/greenroom-robotics/studio
WORKDIR /src
COPY --from=build /src/web/.webpack ./

EXPOSE 8080

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
CMD ["caddy", "file-server", "--listen", ":8080"]
