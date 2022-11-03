# Install dependencies only when needed
FROM node:16-alpine AS deps

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:16-alpine AS builder

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules

COPY . .

RUN yarn build

# Production image, copy all the files and run next
FROM nginx:latest AS runner

COPY --from=builder /app/dist/ /usr/share/nginx/html

EXPOSE 80
