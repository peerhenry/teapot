import std.stdio, std.experimental.logger.core:Logger;
import gfm.opengl, gfm.assimp, gfm.logger;
import poodinis;
import engine;
import teapot;

void main()
{
	writeln("Starting up...");
	auto container = bootstrap();
	auto game = container.resolve!Game;
	scope(exit) game.destroy;
	auto context = container.resolve!Context;
	scope(exit) context.destroy;
	writeln("Running game...");
	context.run(game);
}

shared(DependencyContainer) bootstrap()
{
	auto container = new shared DependencyContainer();

	int width = 1600;
	int height = 900;
	Context context = new Context(width, height, "Teapot");

	container.register!Context.existingInstance(context);
	container.register!OpenGL.existingInstance(context.gl);
	container.register!Logger.existingInstance(context.logger);
	container.register!Camera;
	container.register!Skybox;

	container.register!InputHandler;

	container.register!(ISceneProgram, PhongProgram);
	container.register!Assimp;
	container.register!ModelMatrixSetter;
	container.register!TeapotModel;
	container.register!TeapotScene;
	
	container.register!(Game, TeapotGame);

	return container;
}

unittest{
	auto game = container.resolve!Game;
	scope(exit) game.destroy;
	auto context = container.resolve!Context;
	scope(exit) context.destroy;
}