const { promisify } = require("util");
const exec = promisify(require("child_process").exec);
var spawn = require("child_process").spawn;
var spawnSync = require("child_process").spawnSync;
var execSync = require("child_process").execSync;
var path = require("path");
const fs = require("fs").promises;
const stat = require("fs").promises;
const readline = require("readline");
const fsExtra = require("fs-extra");
var file = "exercises/functions/1_Structure.sol";

const exerciseDirectory = "./exercises";
const tempContracts = "./contracts";

interface progress {
  path: string;
  name: any;
  type: any;
}

const tutorialLogic = {
  testMappings: null,

  // triggered by a save using nodemon
  mainExerciseLogic: async function() {
    // clear artifacts
    await tutorialLogic.clearPreviousArtifacts();

    // clear solidity
    await tutorialLogic.clearTempContracts();

    let prog: progress | null;

    // get exercise to start at
    // let startPoint;
    // try {
    //   startPoint =
    //     parseInt(await tutorialLogic.getUserInput("Start exercise at?")) - 1;
    // } catch (e) {
    //   startPoint = 0;
    // }

    // console.log("startPoint: ", startPoint);

    // Change this to drop into the right theme
    let startPoint = 0;

    console.log("Starting form topic/them: ", startPoint + 1);
    prog = await tutorialLogic.getCurrentExercise(startPoint);

    console.log("prog: ", prog);

    // check if null
    if (prog != null) {
      // load test mappings
      //   tutorialLogic.loadMapping();

      // get file type extension
      let ft: string = prog.type.substr(0, prog.type.indexOf(" "));

      // get compound path
      let fileSource: string = prog.path + "/" + prog.name + "." + ft;

      //
      console.log(
        `\n\nChecking exercise: ${prog.name +
          "." +
          ft}\n*************************************************************\n`
      );

      // copy it to contracts
      await tutorialLogic.copyContract(fileSource);

      console.log(`Compiling contract: ${prog.name}`);

      // compile solidity code
      let compilationResult = await tutorialLogic.compileContracts();

      // test
      if (compilationResult) {
        console.log(`Compile succesfull: ${prog.name}`);
        console.log(`Testing contract:   ${prog.name}`);
        if (await tutorialLogic.testSmartContract(prog)) {
          console.log(`\nContract ${prog.name} passed all tests`);
          console.log("\n\n\t\t( ͡° ͜ʖ ͡°)\n");
        } else {
          console.log(
            `\nSome of the tests for contract ${prog.name} failed, try again after fixing them`
          );
          console.log("\n\n\t\t¯\\_(ツ)_/¯\n");
        }
      } else {
        console.log(
          "Failed compiling: ",
          prog.name,
          "\tcheck the syntax and try again"
        );
        console.log("\n\n\t\t¯\\_( ͡° ͜ʖ ͡°)_/¯\n");
      }
    } else {
      console.log("\n\nWELL DONE ALL EXERCISES ARE FINISHED\n\n");
    }
  },

  getUserInput: async function(text: string = "Input text"): Promise<string> {
    const rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout,
    });

    let user_input: string = "";

    console.log(text);

    for await (const ui of rl) {
      user_input = ui;

      rl.close();
    }

    return user_input;
  },

  getPathContent: async function(newPath: string) {
    // move pathContent otherwise can have conflicts with concurrent requests
    const pathContent: any[] = [];

    let files = await fs.readdir(newPath);

    let pathName = newPath;
    // pathContent.length = 0;  // not needed anymore because pathContent is new for each request

    const absPath = path.resolve(pathName);

    for (let file of files) {
      // get file info and store in pathContent
      try {
        if (file[0] != ".") {
          let stats = await stat.stat(absPath + "/" + file);
          if (stats.isFile()) {
            pathContent.push({
              path: pathName,
              name: file.substring(0, file.lastIndexOf(".")),
              type: file.substring(file.lastIndexOf(".") + 1).concat(" File"),
            });
          } else if (stats.isDirectory()) {
            pathContent.push({
              path: pathName,
              name: file,
              type: "Directory",
            });
          }
        }
      } catch (err) {
        console.log(`${err}`);
      }
    }
    console.log("Returning pathContent");
    return pathContent;
  },

  checkFileFinished: async function(file: string): Promise<boolean> {
    const fileData = await fs.readFile(file, "binary");

    console.log("fileData: ", fileData);

    if (fileData.includes("## I AM NOT DONE")) {
      return false;
    }
    return true;
  },

  loadTestMapping: async function(): Promise<any> {
    // tutorialLogic.testMappings =
    return JSON.parse(await fs.readFile("testMappings.json", "utf8"));
  },

  runSpecificTest: async function(test_name: progress): Promise<boolean> {
    // find matching test to run
    const testCommand: string = "test/" + test_name;

    // let child = await spawnSync("protostar", ["test", testCommand], {
    //   encoding: "utf8",
    // });

    console.log("\nwill invoke shell command programticlly");

    console.log("test command: ", testCommand);

    let child = await spawn(
      "protostar",
      ["test", testCommand, "--disable-hint-validation"],
      {
        encoding: "utf8",
      }
    );
    //
    // var result = execSync(`protostar test ${testCommand}`, {
    //   maxBuffer: 2000 * 1024,
    // }).toString();

    // child.stdout.pipe(process.stdout);

    let data = "";

    // console.log("result: ", result);

    // child.stdout.on("data", function(chunk: any) {
    //   console.log("\n\nreceived chunk \n\n", chunk.toString());
    // });

    // child.stderr.on("data", function(chunk: any) {
    //   console.log("\n\nreceived eerrr \n\n", chunk.toString());
    // });

    child.stderr.on("data", (data: any) => {
      console.log("[1]data start decoded:\n", data.toString(), "\ndata end\n");
      console.log("[1]data start encoded:\n", data, "\ndata end\n\n");
    });

    child.stdout.on("data", (data: any) => {
      console.log("\n[2]data start:\n", data.toString(), "\ndata end [d]\n");
      console.log("\n[2]data start:\n", data, "\ndata end [d]\n");
    });

    // // log as the tests get deployed
    // for await (const chunk of child.stdout) {
    //   // console.log("RRR" + chunk);
    //   // console.log(chunk.toString);
    //   // data += chunk;
    // }
    // let error = "";
    // for await (const chunk of child.stderr) {
    //   console.error("stderr chunk: " + chunk);
    //   // console.error("chunk");
    //   // error += chunk;
    // }
    // const exitCode = await new Promise((resolve, reject) => {
    //   child.on("close", resolve);
    // });

    // console.log("Process finished.");
    // if (child.error) {
    //   console.log("ERROR: ", child.error);
    // }
    // console.log("stdout: ", child.stdout);
    // console.log("stderr: ", child.stderr);
    // console.log("exist code: ", child.status);

    // if (exitCode) {
    //   // throw new Error( `subprocess error exit ${exitCode}, ${error}`);
    //   return false;
    // }

    return true;
  },

  testSmartContract: async function(prog: progress): Promise<boolean> {
    // get mapping
    const testMapping = await tutorialLogic.loadTestMapping();

    // console.log("testMapping: ", testMapping);
    // console.log("testMapping[prog.name] : ", testMapping[prog.name]);

    if (testMapping[prog.name] == undefined) {
      console.log("Missing test file for: ", prog.name);
      process.exit();
    }

    const testResults = await tutorialLogic.runSpecificTest(
      testMapping[prog.name]
    );
    // console.log("\n\nTEST RESULTS\n", testResults);

    return testResults;
  },

  copyContract: async function(source: string) {
    console.log("Contract : ", source);
    // make target file
    var targetFile = "./contracts/" + source.split("/").slice(-1);

    await fs.writeFile(targetFile, await fs.readFile(source));
  },

  // to do update this for cairo
  clearPreviousArtifacts: async function() {
    exec(
      "npx hardhat clean",
      (error: Error, stdout: string, stderr: string) => {
        if (error) {
          // console.log(`error: ${error.message}`);
          return;
        }
        if (stderr) {
          // console.log(`stderr: ${stderr}`);
          return;
        }
        // console.log(`stdout: ${stdout}`);
      }
    );
  },

  clearTempContracts: async function() {
    await fsExtra.emptyDirSync(tempContracts);
  },

  compileContracts: async function(): Promise<boolean> {
    const failure: string = "Compilation failed";
    let compilationOutput: string = "";

    try {
      const { stdout, stderr, error } = await exec("npx hardhat compile");
      if (error.message)
        compilationOutput = compilationOutput.concat(error.message);
      if (stderr) compilationOutput = compilationOutput.concat(stderr);
      if (stdout) compilationOutput = compilationOutput.concat(stdout);
    } catch (error) {
      if (error instanceof Error)
        compilationOutput = compilationOutput.concat(error.message);
    }

    // check if failure message is embedded
    // TODO add check for warnings
    if (compilationOutput.includes(failure) == false) {
      // console.log("Compile Succesful");
      return true;
    }
    // console.log("Failed to compile, check the syntax and try again");
    return false;
  },

  setExercise: async function(themeIndex: number): Promise<progress | null> {
    let prog: progress | null = null;

    const themes = await tutorialLogic.getPathContent(exerciseDirectory);

    console.log("tyhemes: ", themes);

    const exercises = await tutorialLogic.getPathContent(
      themes[themeIndex].path + "/" + themes[themeIndex].name
    );

    console.log("exercises: ", exercises);

    prog = exercises[themeIndex];

    return prog;
  },

  // check all the files
  getCurrentExercise: async function(
    startPoint: number = 0
  ): Promise<progress | null> {
    // loop over themed directories
    const exercises: any[] = await tutorialLogic.getPathContent(
      exerciseDirectory
    );

    let prog: progress | null = null;

    // loop over alpahebitcally
    // for (let exDir = startPoint; exDir < themes.length; exDir++) {
    //   console.log(
    //     `themes[exDir]['path'] + "/" + themes[exDir].name:`,
    //     themes[exDir].path + "/" + themes[exDir].name
    //   );

    //   // const exercises = await tutorialLogic.getPathContent(
    //   //   themes[exDir].path + "/" + themes[exDir].name
    //   // );

    //   console.log("\n\ntheme ex: ", exercises);

    // loop over exercise files
    for (let ex = 0; ex < exercises.length; ex++) {
      console.log(
        "exercises[ex]['path'] + '/' + exercises[ex].name: ",
        exercises[ex].path + "/" + exercises[ex].name,
        ":  ",
        exercises[ex].type.substr(0, exercises[ex].type.indexOf(" "))
      );

      // get file type
      let ft = exercises[ex].type.substr(0, exercises[ex].type.indexOf(" "));

      console.log("ft: ", ft);

      // get compound path
      let comp = exercises[ex].path + "/" + exercises[ex].name + "." + ft;

      if (
        ft == "cairo" &&
        (await tutorialLogic.checkFileFinished(
          exercises[ex].path + "/" + exercises[ex].name + "." + ft
        )) == false
      ) {
        console.log("ex finished");
        prog = exercises[ex];
        return prog;
      }
      // }
    }

    return prog;
  },
};

async function runTutorialLogic() {
  await tutorialLogic.mainExerciseLogic();
}

runTutorialLogic();

// TODO  remove contract laoding into a sperate file since not necessry for protostar
