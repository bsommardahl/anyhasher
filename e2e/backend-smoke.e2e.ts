import axios from "axios";

async function main() {
  try {
    const baseUrl = (<any>process).env.BACKEND_URL;
    if (!baseUrl) throw Error("No BACKEND_URL defined.");
    const url = `${baseUrl}/hash/test`;
    const res = await axios.get(url);
    console.log(res);
    const match = res.data === "098f6bcd4621d373cade4e832627b4f6";
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