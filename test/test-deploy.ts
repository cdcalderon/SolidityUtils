import { SimpleStorage, SimpleStorage__factory } from "../typechain-types";
import { ethers } from "hardhat";
import { assert, expect } from "chai";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { BigNumber, ContractReceipt, ContractTransaction } from "ethers";

//const { ethers } = require("hardhat");
//const { expect, assert } = require("chai");

// describe("SimpleStorage", () => {})
describe("SimpleStorage", () => {
  // let simpleStorageFactory
  // let simpleStorage
  let simpleStorageFactory: SimpleStorage__factory;
  let simpleStorage: SimpleStorage;
  beforeEach(async () => {
    simpleStorageFactory = await ethers.getContractFactory("SimpleStorage");
    simpleStorage = await simpleStorageFactory.deploy();
  });

  it("Should start with a favorite number of 0", async () => {
    const currentValue = await simpleStorage.retrieve();
    const expectedValue = "0";
    // assert
    // expect
    assert.equal(currentValue.toString(), expectedValue);
    // expect(currentValue.toString()).to.equal(expectedValue)
  });
  it("Should update when we call store", async () => {
    const expectedValue = "7";
    const transactionResponse = await simpleStorage.store(expectedValue);
    await transactionResponse.wait(1);

    const currentValue = await simpleStorage.retrieve();
    assert.equal(currentValue.toString(), expectedValue);
  });

  // Extra - this is not in the video
  it("Should work correctly with the people struct and array", async () => {
    const expectedPersonName = "Patrick";
    const expectedFavoriteNumber = "16";
    const transactionResponse = await simpleStorage.addPerson(
      expectedPersonName,
      expectedFavoriteNumber
    );
    await transactionResponse.wait(1);
    const { favoriteNumber, name } = await simpleStorage.people(0);
    // We could also do it like this
    // const person = await simpleStorage.people(0)
    // const favNumber = person.favoriteNumber
    // const pName = person.name

    assert.equal(name, expectedPersonName);
    assert.equal(favoriteNumber.toString(), expectedFavoriteNumber);
  });
});
