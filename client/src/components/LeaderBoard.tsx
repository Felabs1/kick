import React, { useState } from 'react';
import { ChevronLeft, Search, TrendingUp, TrendingDown, Minus } from 'lucide-react';
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer } from 'recharts';

const Leaderboard = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [timeRange, setTimeRange] = useState('weekly');

  // Mock data for leaderboard
  const leaderboardData = [
    { rank: 1, name: "Crypto Kickers", points: 2150, weeklyChange: 50, avatar: "/api/placeholder/32/32" },
    { rank: 2, name: "Blockchain United", points: 2100, weeklyChange: -20, avatar: "/api/placeholder/32/32" },
    { rank: 3, name: "NFT Rovers", points: 2050, weeklyChange: 30, avatar: "/api/placeholder/32/32" },
    { rank: 4, name: "Ethereum Athletic", points: 2000, weeklyChange: 0, avatar: "/api/placeholder/32/32" },
    { rank: 5, name: "Solana Strikers", points: 1950, weeklyChange: 40, avatar: "/api/placeholder/32/32" },
    { rank: 6, name: "DeFi Dynamos", points: 1900, weeklyChange: -10, avatar: "/api/placeholder/32/32" },
    { rank: 7, name: "Chainlink Champions", points: 1850, weeklyChange: 20, avatar: "/api/placeholder/32/32" },
    { rank: 8, name: "Polkadot Punters", points: 1800, weeklyChange: -5, avatar: "/api/placeholder/32/32" },
    { rank: 9, name: "Cardano Crushers", points: 1750, weeklyChange: 15, avatar: "/api/placeholder/32/32" },
    { rank: 10, name: "Bitcoin Ballers", points: 1700, weeklyChange: 25, avatar: "/api/placeholder/32/32" },
  ];

  // Mock data for performance chart
  const performanceData = [
    { name: 'Week 1', points: 150 },
    { name: 'Week 2', points: 220 },
    { name: 'Week 3', points: 200 },
    { name: 'Week 4', points: 280 },
    { name: 'Week 5', points: 250 },
    { name: 'Week 6', points: 300 },
  ];

  const filteredData = leaderboardData.filter(team =>
    team.name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-900 to-indigo-900 text-white p-8">
      <header className="flex justify-between items-center mb-12">
        <div className="relative">
          <input
            type="text"
            placeholder="Search teams..."
            className="bg-white bg-opacity-20 px-4 py-2 rounded-full pl-10 pr-4 focus:outline-none focus:ring-2 focus:ring-blue-300"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
          <Search className="absolute left-3 top-2.5 text-white opacity-70" size={20} />
        </div>
      </header>

      <main>
        <section className="mb-12">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-2xl font-semibold">Top Performers</h2>
            <div className="flex space-x-2">
              <button
                className={`px-4 py-2 rounded-full ${timeRange === 'weekly' ? 'bg-blue-500' : 'bg-white bg-opacity-20'}`}
                onClick={() => setTimeRange('weekly')}
              >
                Weekly
              </button>
              <button
                className={`px-4 py-2 rounded-full ${timeRange === 'monthly' ? 'bg-blue-500' : 'bg-white bg-opacity-20'}`}
                onClick={() => setTimeRange('monthly')}
              >
                Monthly
              </button>
              <button
                className={`px-4 py-2 rounded-full ${timeRange === 'overall' ? 'bg-blue-500' : 'bg-white bg-opacity-20'}`}
                onClick={() => setTimeRange('overall')}
              >
                Overall
              </button>
            </div>
          </div>
          <div className="bg-white bg-opacity-10 rounded-lg overflow-hidden">
            <table className="w-full">
              <thead className="bg-black bg-opacity-30">
                <tr>
                  <th className="py-3 px-4 text-left">Rank</th>
                  <th className="py-3 px-4 text-left">Team</th>
                  <th className="py-3 px-4 text-right">Points</th>
                  <th className="py-3 px-4 text-right">Weekly Change</th>
                </tr>
              </thead>
              <tbody>
                {filteredData.map((team) => (
                  <tr key={team.rank} className="border-b border-white border-opacity-10">
                    <td className="py-3 px-4">{team.rank}</td>
                    <td className="py-3 px-4 flex items-center">
                      <img src={team.avatar} alt={team.name} className="w-8 h-8 rounded-full mr-3" />
                      {team.name}
                    </td>
                    <td className="py-3 px-4 text-right">{team.points}</td>
                    <td className="py-3 px-4 text-right flex items-center justify-end">
                      {team.weeklyChange > 0 ? (
                        <TrendingUp className="text-green-500 mr-1" size={16} />
                      ) : team.weeklyChange < 0 ? (
                        <TrendingDown className="text-red-500 mr-1" size={16} />
                      ) : (
                        <Minus className="text-yellow-500 mr-1" size={16} />
                      )}
                      {Math.abs(team.weeklyChange)}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </section>

        <section>
          <h2 className="text-2xl font-semibold mb-4">Your Performance</h2>
          <div className="bg-white bg-opacity-10 p-6 rounded-lg">
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={performanceData}>
                <XAxis dataKey="name" stroke="#ffffff" />
                <YAxis stroke="#ffffff" />
                <Tooltip 
                  contentStyle={{ backgroundColor: '#1e3a8a', border: 'none' }}
                  itemStyle={{ color: '#ffffff' }}
                />
                <Bar dataKey="points" fill="#3b82f6" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </section>
      </main>

      <footer className="mt-12 text-center text-sm opacity-70">
        © 2024 Web3 Fantasy Premier League. Powered by Ethereum.
      </footer>
    </div>
  );
};

export default Leaderboard;