# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy all projects preserving folder structure
COPY Subscriber/ ./Subscriber/
COPY Models/ ./Models/

# Restore dependencies
WORKDIR /app/Subscriber
RUN dotnet restore

# Publish
RUN dotnet publish -c Release -o /app/out

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

ENTRYPOINT ["dotnet", "Subscriber.dll"]
