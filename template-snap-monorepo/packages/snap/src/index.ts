import { OnRpcRequestHandler, OnTransactionHandler } from '@metamask/snaps-types';
import { panel, heading, text } from '@metamask/snaps-ui';

async function checkValidity(
  chainId: string,
  contractAddress: string,
  txDest: string,
  origin: string,
) {

  // cut the https:// or http:// from the origin
  origin = origin.replace(/(^\w+:|^)\/\//, '');

  let response;

  try {

    // Fetch with the Access-Control-Allow-Origin header
    response = await fetch(
      `https://eth-tokyo-fullstack.vercel.app/api/checkContract?domain=${origin}&to=${contractAddress}`,
      {
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      }
    )

  } catch (error) {
    return `ERROR: ${error}`;
  }

  const result = await response.json();

  if (result == 0) {
    return `WARNING: The domain ${origin} has not yet registered on the protocol.`;
  } else if (result == 1) {
    return `SUCCESS: The contract ${contractAddress} is verified for domain ${origin} on chain ${chainId}`;
  } else {
    return `WARNING: The domain ${origin} has not verified the contract ${contractAddress} on chain ${chainId}`;
  }
  
}

export const onTransaction: OnTransactionHandler = async ({
  transaction,
  chainId,
  transactionOrigin,
}) => {
  const sourceAddress = transaction.from;
  const destAddress = transaction.to?.toString();
  const chainIdStr = chainId.split(':')[1];

  let origin: string;
  let result: string;

  if (transactionOrigin === undefined) {
    origin = 'UNDEFINED';
    result = 'ERROR: Failed to get web2 origin domain';
  } else if (destAddress === undefined) {
    origin = 'UNDEFINED';
    result = 'ERROR: Failed to get tx destination';
  } else {
    origin = transactionOrigin;

    const domainContract = '0x15e59698A92F844f24ce2AFe8F0b494CeBc836f3';
    // TODO: look up domain contract via dictionary of chainId -> addr
    result = await checkValidity(
      chainIdStr,
      domainContract,
      destAddress,
      origin
    );
  }

  return {
    content: panel([
      heading('My Transaction Insights'),
      text(result),
    ]),
  };
};