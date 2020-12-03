FROM registry.nexdev.net:5050/docker/dotnet/core/sdk:3.1 AS builder
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ./src/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY ./src ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM registry.nexdev.net:5050/docker/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=builder /app/out .
ENTRYPOINT ["dotnet", "dotnet-docker.dll"]