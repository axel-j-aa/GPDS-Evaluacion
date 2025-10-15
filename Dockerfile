# --- Build stage ---
FROM node:20-alpine AS build
WORKDIR /app/backend
COPY backend/package*.json ./
RUN npm ci
COPY backend ./
RUN npm run build

# --- Runtime stage ---
FROM node:20-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app/backend
COPY --from=build /app/backend/dist ./dist
COPY --from=build /app/backend/package*.json ./
RUN npm ci --omit=dev
EXPOSE 4000
CMD ["node", "dist/server.js"]
