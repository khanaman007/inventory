# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the .csproj file and restore any dependencies (via 'dotnet restore')
COPY  inventory.csproj ./

# Restore dependencies
RUN dotnet restore

# Copy the remaining source code and build the application
COPY . ./

# Publish the application
RUN dotnet publish --configuration Release --output /app/publish

# Use the official .NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the published app from the build stage
COPY --from=build /app/publish .

# Expose the required port for App Engine (8080)
EXPOSE 8080

# Set the entry point to start the application
ENTRYPOINT ["dotnet", "inventory.dll"]  # Replace with your actual DLL name
