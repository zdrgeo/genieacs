FROM node:22-slim AS base
WORKDIR /app
ENV NODE_ENV=production

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm ci --omit=dev

COPY . .
RUN npm run build

FROM base AS base-cwmp
EXPOSE 7547
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
    CMD node -e "require('net').createConnection(process.env.HEALTHCHECK_PORT||7547).on('connect',()=>process.exit(0)).on('error',()=>process.exit(1))"

ENTRYPOINT ["npm", "run", "--", "genieacs-cwmp"]

FROM base AS base-nbi
EXPOSE 7557
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
    CMD node -e "require('net').createConnection(process.env.HEALTHCHECK_PORT||7557).on('connect',()=>process.exit(0)).on('error',()=>process.exit(1))"

ENTRYPOINT ["npm", "run", "--", "genieacs-nbi"]

FROM base AS base-fs
EXPOSE 7567
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
    CMD node -e "require('net').createConnection(process.env.HEALTHCHECK_PORT||7567).on('connect',()=>process.exit(0)).on('error',()=>process.exit(1))"

ENTRYPOINT ["npm", "run", "--", "genieacs-fs"]

FROM base AS base-ui
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s \
    CMD node -e "require('net').createConnection(process.env.HEALTHCHECK_PORT||3000).on('connect',()=>process.exit(0)).on('error',()=>process.exit(1))"

ENTRYPOINT ["npm", "run", "--", "genieacs-ui"]
