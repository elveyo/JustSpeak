FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Kopiraj cijeli solution
COPY . .

# Restore cijelog solutiona (svi projekti)
RUN dotnet restore "WebAPI/WebAPI.csproj"

# Build i publish WebAPI
RUN dotnet publish "WebAPI/WebAPI.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENTRYPOINT ["dotnet", "WebAPI.dll"]
