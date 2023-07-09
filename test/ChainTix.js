const { expect } = require("chai")
const { ethers } = require("hardhat");

const NAME = "ChainTix"
const SYMBOL = "CT"

const OCCASION_NAME = "ETH Denver"
const OCCASION_COST = ethers.utils.parseUnits('1','ether')
const OCCATION_MAX_TICKETS = 100
const OCCASION_DATE = "27 April"
const OCCASION_TIME = "10.00 AM CST"
const OCCASION_LOCATION = "Austin, Texas"

describe("ChainTix",() => {
    let chainTix;
    let deployer, buyer;

    beforeEach(async() => {

        [deployer, buyer] = await ethers.getSigners();

        const ChainTix = await ethers.getContractFactory("ChainTix");
        chainTix = await ChainTix.deploy(NAME, SYMBOL);

        const transaction = await chainTix.connect(deployer).list(
            OCCASION_NAME,
            OCCASION_COST,
            OCCATION_MAX_TICKETS,
            OCCASION_DATE,
            OCCASION_TIME,
            OCCASION_LOCATION
        )

        await transaction.wait()
    })

    describe("Deployment",() => {
        it("should set the name", async() => {
            expect(await chainTix.name()).to.equal(NAME);
        });

        it("should set the symbol", async() => {
            expect(await chainTix.symbol()).to.equal(SYMBOL);
        });

        it("should set the owner", async() => {
            expect(await chainTix.owner()).to.equal(deployer.address);
        })
    });

    describe("Occasion",() => {
        it("should update occasion count", async()=> {
            const totalOccasions = await chainTix.totalOccasions();
            expect(totalOccasions).to.be.equal(1);
        })

        it("should return the attributes of occasion", async () => {
            const occasion = await chainTix.getOccasion(1);
            expect(occasion.id).to.be.equal(1);
            expect(occasion.name).to.be.equal(OCCASION_NAME);
            expect(occasion.cost.toString()).to.be.equal(OCCASION_COST.toString());
            expect(occasion.maxTicket.toString()).to.be.equal(OCCATION_MAX_TICKETS.toString());
            expect(occasion.date).to.be.equal(OCCASION_DATE);
            expect(occasion.time).to.be.equal(OCCASION_TIME);
            expect(occasion.location).to.be.equal(OCCASION_LOCATION);
          });         
    })

    describe("Minting", () => {
        const ID = 1
        const SEAT = 50
        const AMOUNT = ethers.utils.parseUnits('1','ether');

        beforeEach(async() => {
            const transaction = await chainTix.connect(buyer).mint(ID, SEAT, { value: AMOUNT });
            await transaction.wait();
        })

        it("",() => {
            // TODO : write test cases for mint and transfer functions
        })

    })
});