FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["task_tracker-projects_microservice.csproj", "./"]
RUN dotnet restore "task_tracker-projects_microservice.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "task_tracker-projects_microservice.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "task_tracker-projects_microservice.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "task_tracker-projects_microservice.dll"]
