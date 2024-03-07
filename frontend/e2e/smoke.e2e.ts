import puppeteer from "puppeteer";

async function getElement(page: puppeteer.Page, selector: string){
  await page.waitForSelector(selector);
  const element = await page.$(selector);
  if (!element) throw new Error(`Element "${selector}" not found on page.`);
  return element;
}

async function getElementValue(page: puppeteer.Page, selector: string){
  const element = await getElement(page, selector);
  const value = await element.evaluate((el: any) => el.textContent);
  if (!value) throw new Error(`Element "${selector}" had no value.`);
  return value;
}

async function verifyElementContainsText(page: puppeteer.Page, selector: string, expectedText: string){
  const value = await getElementValue(page, selector);
  console.log(`Found: ${value}`);
  const found = value.toLowerCase().includes(expectedText.toLowerCase());
  if (!found) {
    throw new Error(`Smoke test failed. "${expectedText}" was not found in element "${selector}".`);
  }
}

async function enterText(page: puppeteer.Page, selector: string, text: string){
  const element = await getElement(page, selector);
  await element.type(text);
}

async function clickElement(page: puppeteer.Page, selector: string){
  const element = await getElement(page, selector);  
  await element.click();
}

async function main(url: string) {
  const browser = await puppeteer.launch();
  try {
    const page = await browser.newPage();
    await page.goto(url);
    await verifyElementContainsText(page, "#page-title", "anyhasher");
    await enterText(page, "input[type=text]", "This had BETTER work!");
    await clickElement(page, "button");
    await verifyElementContainsText(page, "p", "d6115deb306b9655598232c871ef6a04");
    console.log("Smoke test passed.");
    (<any>process).exitCode = 0;
  } catch (err) {
    (<any>process).exitCode = 1;
    throw err;
  } finally {
    await browser.close();    
  }
}

const url = <any>process.env.TEST_URL || "http://localhost:3000/";
if (!url) throw Error("No TEST_URL defined.");    
main(url);