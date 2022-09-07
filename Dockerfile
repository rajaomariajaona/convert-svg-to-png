FROM node:14-slim
RUN apt-get update \
    && apt-get install -y wget gnupg \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
      --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*
ENV PUPPETEER_EXECUTABLE_PATH chrome-launcher.sh
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
WORKDIR /usr/src/app
COPY package.json .
COPY yarn.lock .
RUN yarn install
COPY . .
RUN groupadd -r pptruser && useradd -r -g pptruser -G audio,video pptruser \
    && mkdir -p /home/pptruser/Downloads \
    && chown -R pptruser:pptruser /home/pptruser \
    && chown -R pptruser:pptruser node_modules \
    && chown -R pptruser:pptruser package.json \
    && chown -R pptruser:pptruser yarn.lock \
    && chown -R pptruser:pptruser * \
    && chown pptruser:pptruser chrome-launcher.sh \
    && chmod +x chrome-launcher.sh
USER pptruser

EXPOSE 3000
CMD [ "node", "index.js" ]
#git clone https://github.com/rajaomariajaona/convert-svg-to-png.git
#cd convert-svg-to-png
#docker build . -t rajaomariajaona/convert-svg-to-png
#docker run -p 4321:3000 --name test rajaomariajaona/convert-svg-to-png