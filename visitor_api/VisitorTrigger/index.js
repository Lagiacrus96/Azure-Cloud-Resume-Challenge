const { CosmosClient } = require("@azure/cosmos");

module.exports = async function (context, req) {
    try {
        const endpoint = process.env["COSMOS_DB_ENDPOINT"];
        const key = process.env["COSMOS_DB_KEY"];

        if (!endpoint || !key) {
            throw new Error("COSMOS_DB_ENDPOINT or COSMOS_DB_KEY environment variables are not set.");
        }

        const client = new CosmosClient({ endpoint, key });
        const databaseId = "CloudWebsiteDatabase";
        const containerId = "VisitorCounter";
        const container = client.database(databaseId).container(containerId);

        const visitorId = req.query.visitorId || (req.body && req.body.visitorId) || "defaultVisitor";

        const { resource: visitor } = await container.item(visitorId, visitorId).read();

        let count = 1;
        if (visitor) {
            count = visitor.count + 1;
            visitor.count = count;
            await container.item(visitorId, visitorId).replace(visitor);
        } else {
            const newVisitor = { id: visitorId, count };
            await container.items.create(newVisitor);
        }

        context.res = {
            status: 200,
            body: `Visitor count for ${visitorId} is ${count}`
        };
    } catch (error) {
        context.log.error("Error processing request:", error.message);
        context.res = {
            status: 500,
            body: `Error processing request: ${error.message}`
        };
    }
};
