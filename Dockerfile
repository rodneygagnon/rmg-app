FROM node:20-slim AS base

### Install the dependencies ###
FROM base AS deps
 
RUN corepack enable
WORKDIR /app
COPY package.json pnpm-lock.yaml ./

RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm fetch --frozen-lockfile
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

### Build the project ###
FROM base AS builder
 
RUN corepack enable
WORKDIR /app
COPY package.json pnpm-lock.yaml ./

RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm fetch --frozen-lockfile
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

COPY . .

RUN pnpm build

### Run the project ###
FROM base AS runner

WORKDIR /app
ENV NODE_ENV=production
RUN addgroup --system --gid 1001 group1
RUN adduser --system --uid 1001 user1

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER user1
ENV PORT=3000
EXPOSE $PORT

CMD [ "node", "server.js" ]