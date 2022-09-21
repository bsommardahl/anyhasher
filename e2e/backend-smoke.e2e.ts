import axios from "axios";

async function main() {
  try {
    const url = process.env.BACKEND_URL;
    if (!url) throw Error("No TEST_URL defined.");
    const res = await axios({ url: `${url}/hash/test` });
    console.log(res);
    const match = res.data === "testhashed";
    if (!match) {
      console.log(match);
      throw new Error("Smoke test failed.");
    }
    console.log("Smoke test passed.");
    (<any>process).exitCode = 0;
  } catch (err) {
    (<any>process).exitCode = 1;
    throw err;
  }
}

main();