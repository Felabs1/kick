import React from 'react';
import { Users, Plus, ChevronLeft, Trophy } from 'lucide-react';

const League = () => {
  // Mock data for league standings
  const leagueStandings = [
    { rank: 1, name: "Crypto Kickers", points: 2150, avatar: "/api/placeholder/32/32" },
    { rank: 2, name: "Blockchain United", points: 2100, avatar: "/api/placeholder/32/32" },
    { rank: 3, name: "NFT Rovers", points: 2050, avatar: "/api/placeholder/32/32" },
    { rank: 4, name: "Ethereum Athletic", points: 2000, avatar: "/api/placeholder/32/32" },
    { rank: 5, name: "Solana Strikers", points: 1950, avatar: "/api/placeholder/32/32" },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 to-indigo-900 text-white p-8">
      <header className="flex justify-between items-center mb-12">
        <button className="bg-yellow-500 text-black px-4 py-2 rounded-full flex items-center">
          <Users className="mr-2" size={20} />
          My Leagues
        </button>
      </header>

      <main>
        <section className="mb-12">
          <h2 className="text-2xl font-semibold mb-4">League Actions</h2>
          <div className="flex space-x-4">
            <button className="bg-green-500 text-white px-6 py-3 rounded-lg flex items-center">
              <Users className="mr-2" size={20} />
              Join League
            </button>
            <button className="bg-purple-500 text-white px-6 py-3 rounded-lg flex items-center">
              <Plus className="mr-2" size={20} />
              Create League
            </button>
          </div>
        </section>

        <section className="mb-12">
          <h2 className="text-2xl font-semibold mb-4">Global League Standings</h2>
          <div className="bg-white bg-opacity-10 rounded-lg overflow-hidden">
            <table className="w-full">
              <thead className="bg-black bg-opacity-30">
                <tr>
                  <th className="py-3 px-4 text-left">Rank</th>
                  <th className="py-3 px-4 text-left">Team</th>
                  <th className="py-3 px-4 text-right">Points</th>
                </tr>
              </thead>
              <tbody>
                {leagueStandings.map((team) => (
                  <tr key={team.rank} className="border-b border-white border-opacity-10">
                    <td className="py-3 px-4">{team.rank}</td>
                    <td className="py-3 px-4 flex items-center">
                      <img src={team.avatar} alt={team.name} className="w-8 h-8 rounded-full mr-3" />
                      {team.name}
                    </td>
                    <td className="py-3 px-4 text-right">{team.points}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-4">Recent Results</h2>
          <div className="bg-white bg-opacity-10 p-6 rounded-lg">
            <ul>
              <li className="mb-2 flex justify-between items-center">
                <span>Crypto Kickers 65 - 52 Blockchain United</span>
                <Trophy className="text-yellow-500" size={20} />
              </li>
              <li className="mb-2">NFT Rovers 58 - 61 Ethereum Athletic</li>
              <li>Solana Strikers 70 - 68 DeFi Dynamos</li>
            </ul>
          </div>
        </section>
      </main>

      <footer className="mt-12 text-center text-sm opacity-70">
        © 2024 Web3 Fantasy Premier League. Powered by Ethereum.
      </footer>
    </div>
  );
};

export default League;