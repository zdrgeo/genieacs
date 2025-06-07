FROM node:22-slim AS base
WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm install --omit=dev

COPY . .
RUN npm run build

FROM base AS genieacs-cwmp
EXPOSE 7547

ENTRYPOINT ["node", "bin/genieacs-cwmp"]

FROM base AS genieacs-nbi
EXPOSE 7557

ENTRYPOINT ["node", "bin/genieacs-nbi"]

FROM base AS genieacs-fs
EXPOSE 7567

ENTRYPOINT ["node", "bin/genieacs-fs"]

FROM base AS genieacs-ui
EXPOSE 3000

ENTRYPOINT ["node", "bin/genieacs-ui"]
