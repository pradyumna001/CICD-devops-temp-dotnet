FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 5015
EXPOSE 7018

ENV ASPNETCORE_URLS=http://+:5015

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["cicd-temp-api.csproj", "./"]
RUN dotnet restore "cicd-temp-api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "cicd-temp-api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "cicd-temp-api.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "cicd-temp-api.dll"]
