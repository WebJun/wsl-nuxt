### 무엇을 해결했나
WSL에서 nuxt 설치시, 호스트os 브라우저에서 접속이 안되는 문제  
 -> docker로 nginx를 설치하여 proxy하였음.  
 -> (뭔가 더 좋은 방법이 있을 것 같음)  

### 실행
git clone https://github.com/WebJun/wsl-nuxt  
cd wsl-nuxt
docker-compose up -d --build  
docker exec -it wsl-nuxt-web-1 su scv -c "tar -zxvf node_modules.tar.gz"  
./start.sh  
http://localhost:3000/  

### version info
root@dcff54602b92:/app# npm -v  
9.6.6  
root@dcff54602b92:/app# node -v  
v16.20.0  
  
"nuxt": "^2.15.8",  
  
create-nuxt-app v5.0.0  
✨  Generating Nuxt.js project in app  
? Project name: app  
? Programming language: TypeScript  
? Package manager: Yarn  
? UI framework: Bootstrap Vue  
? Template engine: HTML  
? Nuxt.js modules: Axios - Promise based HTTP client, Progressive Web App (PWA), Content - Git-based headless CMS  
? Linting tools: Prettier  
? Testing framework: None  
? Rendering mode: Universal (SSR / SSG)  
? Deployment target: Server (Node.js hosting)  
? Development tools: jsconfig.json (Recommended for VS Code if you're n  
ot using typescript)  
? Continuous integration: None  
? Version control system: Git  
