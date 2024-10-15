import React, { useState } from 'react';
import { ChevronLeft, Shirt, DollarSign, Award, BarChart2 } from 'lucide-react';

const TeamManagement = () => {
  const [selectedPosition, setSelectedPosition] = useState('All');

  // Mock data for team players
  const teamPlayers = [
    { id: 1, name: "De Gea", position: "GK", value: 5.5, points: 34, team: "MUN", avatar: "/api/placeholder/48/48" },
    { id: 2, name: "Alexander-Arnold", position: "DEF", value: 7.5, points: 52, team: "LIV", avatar: "/api/placeholder/48/48" },
    { id: 3, name: "Cancelo", position: "DEF", value: 7.0, points: 48, team: "MCI", avatar: "/api/placeholder/48/48" },
    { id: 4, name: "James", position: "DEF", value: 6.0, points: 45, team: "CHE", avatar: "/api/placeholder/48/48" },
    { id: 5, name: "De Bruyne", position: "MID", value: 12.0, points: 76, team: "MCI", avatar: "/api/placeholder/48/48" },
    { id: 6, name: "Salah", position: "MID", value: 13.0, points: 90, team: "LIV", avatar: "/api/placeholder/48/48" },
    { id: 7, name: "Son", position: "MID", value: 11.5, points: 80, team: "TOT", avatar: "/api/placeholder/48/48" },
    { id: 8, name: "Saka", position: "MID", value: 8.0, points: 65, team: "ARS", avatar: "/api/placeholder/48/48" },
    { id: 9, name: "Haaland", position: "FWD", value: 12.5, points: 85, team: "MCI", avatar: "/api/placeholder/48/48" },
    { id: 10, name: "Kane", position: "FWD", value: 11.0, points: 75, team: "TOT", avatar: "/api/placeholder/48/48" },
    { id: 11, name: "Mitrovic", position: "FWD", value: 6.5, points: 55, team: "FUL", avatar: "/api/placeholder/48/48" },
  ];

  const filteredPlayers = selectedPosition === 'All' 
    ? teamPlayers 
    : teamPlayers.filter(player => player.position === selectedPosition);

  const totalValue = teamPlayers.reduce((sum, player) => sum + player.value, 0);
  const totalPoints = teamPlayers.reduce((sum, player) => sum + player.points, 0);

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 to-slate-900 text-white p-8">
      <header className="flex justify-between items-center mb-12">
        <button className="bg-green-500 text-white px-4 py-2 rounded-full">
          Save Team
        </button>
      </header>

      <main>
        <section className="mb-12 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
            <Shirt className="mr-4 text-slate-400" size={32} />
            <div>
              <h3 className="font-semibold">Squad</h3>
              <p>11/15 Players</p>
            </div>
          </div>
          <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
            <DollarSign className="mr-4 text-green-400" size={32} />
            <div>
              <h3 className="font-semibold">Team Value</h3>
              <p>{totalValue.toFixed(1)} ETH</p>
            </div>
          </div>
          <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
            <Award className="mr-4 text-yellow-400" size={32} />
            <div>
              <h3 className="font-semibold">Total Points</h3>
              <p>{totalPoints} pts</p>
            </div>
          </div>
          <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
            <BarChart2 className="mr-4 text-purple-400" size={32} />
            <div>
              <h3 className="font-semibold">Rank</h3>
              <p>#1,234 / 1M</p>
            </div>
          </div>
        </section>

        <section className="mb-8">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-semibold">Your Players</h2>
            <div className="flex space-x-2">
              {['All', 'GK', 'DEF', 'MID', 'FWD'].map(pos => (
                <button
                  key={pos}
                  className={`px-4 py-2 rounded-full ${selectedPosition === pos ? 'bg-slate-500' : 'bg-white bg-opacity-20'}`}
                  onClick={() => setSelectedPosition(pos)}
                >
                  {pos}
                </button>
              ))}
            </div>
          </div>
          <div className="bg-white bg-opacity-10 rounded-lg overflow-hidden">
            <table className="w-full">
              <thead className="bg-black bg-opacity-30">
                <tr>
                  <th className="py-3 px-4 text-left">Player</th>
                  <th className="py-3 px-4 text-center">Position</th>
                  <th className="py-3 px-4 text-center">Team</th>
                  <th className="py-3 px-4 text-right">Value (ETH)</th>
                  <th className="py-3 px-4 text-right">Points</th>
                </tr>
              </thead>
              <tbody>
                {filteredPlayers.map((player) => (
                  <tr key={player.id} className="border-b border-white border-opacity-10">
                    <td className="py-3 px-4 flex items-center">
                      <img src={player.avatar} alt={player.name} className="w-8 h-8 rounded-full mr-3" />
                      {player.name}
                    </td>
                    <td className="py-3 px-4 text-center">{player.position}</td>
                    <td className="py-3 px-4 text-center">{player.team}</td>
                    <td className="py-3 px-4 text-right">{player.value.toFixed(1)}</td>
                    <td className="py-3 px-4 text-right">{player.points}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-4">Transfer Market</h2>
          <div className="bg-white bg-opacity-10 p-6 rounded-lg">
            <p className="mb-4">Browse available players and make transfers to improve your team.</p>
            <button className="bg-slate-500 text-white px-6 py-3 rounded-lg">
              Open Transfer Market
            </button>
          </div>
        </section>
      </main>

      <footer className="mt-12 text-center text-sm opacity-70">
        © 2024 Web3 Fantasy Premier League. Powered by Ethereum.
      </footer>
    </div>
  );
};

export default TeamManagement;