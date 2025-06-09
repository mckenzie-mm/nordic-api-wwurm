# Stage 1: Build stage
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build

WORKDIR /app

# Copy everything
COPY . ./

# Restore as distinct layers
RUN dotnet restore 

# Build and publish a release
RUN dotnet publish -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 
ENV ASPNETCORE_HTTP_PORTS=5000
EXPOSE 5000
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT [ "dotnet", "webapi.dll" ]
