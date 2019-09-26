    
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build-env
WORKDIR /

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c /p:MicrosoftNETPlatformLibrary=Microsoft.NETCore.App Release -o out

# Build runtime image
FROM microsoft/dotnet:2.2-aspnetcore-runtime
WORKDIR /
COPY --from=build-env /out .
CMD dotnet herokutest.dll
