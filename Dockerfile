FROM node:14

ENV SECRET_WORD=$SECRET_WORD

ENV PORT=3000

WORKDIR /usr/src/app

COPY src/ src/
COPY bin/ bin/

RUN npm install express

EXPOSE 3000


CMD ["node", "src/000.js"]