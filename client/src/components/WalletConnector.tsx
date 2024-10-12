import React, { useState } from 'react';
import { useAccount, useConnect, useDisconnect } from 'wagmi';
import { Wallet, X, ChevronRight } from 'lucide-react';

// Utility function to shorten address
const shortenAddress = (addr: `0x${string}`) => {
  if (!addr) return '';
  return `${addr.slice(0, 6)}...${addr.slice(-4)}`;
};

// Connect Button Component
export const ConnectButton = ({ onClick }: { onClick: () => void }) => {
  const { address, isConnected } = useAccount();

  return (
    <button
      onClick={onClick}
      className="bg-yellow-500 text-black px-4 py-2 rounded-full flex items-center"
    >
      <Wallet className="mr-2" size={20} />
      {isConnected ? shortenAddress(address!) : 'Connect Wallet'}
    </button>
  );
};

// Modal Component
export const WalletConnectorModal = ({ isOpen, onClose }: { isOpen: boolean; onClose: () => void }) => {
  const { address, isConnected } = useAccount();
  const { connect, connectors, error, status } = useConnect();
  const { disconnect } = useDisconnect();

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 backdrop-blur-sm flex items-center justify-center p-4 z-50">
      <div className="bg-white rounded-2xl shadow-xl max-w-md w-full overflow-hidden">
        <div className="flex justify-between items-center p-6 bg-gray-50">
          <h2 className="text-xl font-semibold text-gray-900">Connect Wallet</h2>
          <button onClick={onClose} className="text-gray-400 hover:text-gray-500 transition-colors">
            <X size={24} />
          </button>
        </div>

        <div className="p-6">
          {isConnected ? (
            <div className="mb-4">
              <div className="flex items-center justify-between bg-green-50 p-4 rounded-xl border border-green-200">
                <div>
                  <p className="text-sm font-medium text-green-800">Connected</p>
                  <p className="text-xs text-green-600 truncate">{address}</p>
                </div>
                <button
                  onClick={() => {
                    disconnect();
                    onClose();
                  }}
                  className="ml-2 bg-red-500 text-white p-2 rounded-full hover:bg-red-600 transition-colors focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2"
                >
                  <X size={16} />
                </button>
              </div>
            </div>
          ) : (
            <div className="space-y-3">
              {connectors.map((connector) => (
                <button
                  key={connector.id}
                  onClick={() => {
                    connect({ connector });
                    if (status !== 'error') onClose();
                  }}
                  type="button"
                  className="w-full flex items-center justify-between px-4 py-3 rounded-xl text-gray-700 font-medium bg-gray-50 hover:bg-gray-100 transition-colors duration-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                >
                  <div className="flex items-center space-x-3">
                    <Wallet size={20} className="text-indigo-600" />
                    <span>{connector.name}</span>
                  </div>
                  <ChevronRight size={20} className="text-gray-400" />
                </button>
              ))}
            </div>
          )}

          {error && (
            <div className="mt-4 p-4 bg-red-50 border border-red-200 text-red-700 rounded-xl">
              <p className="text-sm">{error.message}</p>
            </div>
          )}

          {status === 'pending' && (
            <div className="mt-4 p-4 bg-blue-50 border border-blue-200 text-blue-700 rounded-xl">
              <p className="text-sm">Connecting...</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

// Usage example
const WalletConnection = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);

  return (
    <>
      <ConnectButton onClick={() => setIsModalOpen(true)} />
      <WalletConnectorModal isOpen={isModalOpen} onClose={() => setIsModalOpen(false)} />
    </>
  );
};

export default WalletConnection;