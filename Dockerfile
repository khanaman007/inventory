# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the .csproj file and restore any dependencies (via 'dotnet restore')
COPY *.csproj ./
RUN dotnet restore

# Copy the entire project and publish the app to the /app/publish directory
COPY . ./
RUN dotnet publish --configuration Release --output /app/publish

# Use the official .NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the published app from the build stage
COPY --from=build /app/publish .

# Expose the port that the app will run on
EXPOSE 8080

# Define the entrypoint to run the app
ENTRYPOINT ["dotnet", "inventory.dll"]