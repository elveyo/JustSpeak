# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copy project file and restore
COPY Subscriber.csproj ./
COPY ../Models/Models.csproj ./Models/
RUN dotnet restore

# Copy all source code
COPY . ./

# Publish as single file, trimmed for smaller size
RUN dotnet publish "Subscriber.csproj" -c Release -o /app/out


# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

ENTRYPOINT ["dotnet", "Subscriber.dll"]
