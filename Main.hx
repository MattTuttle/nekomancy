import sys.FileSystem;
import sys.io.Process;

#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

class Main
{

	static var module = "";
	static var verbose = false;
	static var process:Process;

	static function readProcess()
	{
		var mainThread = Thread.readMessage(true);
		try {
			print(process.stdout.readAll().toString());
			if (process.exitCode() != 0)
			{
				print(process.stderr.readAll().toString());
			}
		} catch (e:Dynamic) { }
		mainThread.sendMessage("done");
	}

	static function print(msg)
	{
		if (verbose) Sys.println(msg);
	}

	public static function main()
	{
		var args = Sys.args();
		if (args.length < 1)
		{
			Sys.println("USAGE: nekomancy [-v] <module.n>");
			Sys.exit(1);
		}

		// var process:Process = null;
		var lastTime:Float = 0;

		for (arg in args)
		{
			switch (arg)
			{
				case "-v":
					verbose = true;
				default:
					module = arg;
			}
		}

		while (FileSystem.exists(module))
		{
			var stat = FileSystem.stat(module);
			var newTime = stat.mtime.getTime();
			if (lastTime != newTime)
			{
				if (process != null)
				{
					// use a thread to read the process output
					var thread = Thread.create(readProcess);
					thread.sendMessage(Thread.current());
					// must kill the process now to prevent a hanging thread
					process.kill();
					Thread.readMessage(true);
					print('killed $module\n');
				}
				print('starting $module...');
				process = new Process("neko", [module]);
				lastTime = newTime;
			}
			Sys.sleep(0.5);
		}
	}
}
