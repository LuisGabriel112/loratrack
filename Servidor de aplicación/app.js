import Fastify from 'fastify'

const app = Fastify({
  logger: true
})
app.get('/', async (request, reply) => {
  return { hello: 'world' };
});

const start = async () => {
  try {
    const puerto = 5500
    const hosta = "0.0.0.0"
    await app.listen({ port: puerto, host: hosta});
    console.log(`Server listening on http://${hosta}:${app.server.address().port}`);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

start();