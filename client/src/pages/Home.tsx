import React, { useState, useEffect } from 'react';
import { Wallet, Trophy, Users, TrendingUp, Home as HomeIcon, Briefcase, BarChart2, Settings, HelpCircle, Menu, X, Clipboard } from 'lucide-react';
import Leaderboard from '../components/LeaderBoard';
import League from '../components/League';
import TeamManagement from '../components/Team';
import GamePlan from '../components/Gameplan';

const Home = () => {
  const [activeMenu, setActiveMenu] = useState('home');
  const [isMobile, setIsMobile] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(false);

  useEffect(() => {
    const handleResize = () => {
      setIsMobile(window.innerWidth < 768);
    };
    handleResize();
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const menuItems = [
    { icon: HomeIcon, label: 'Home' },
    { icon: Briefcase, label: 'My Team' },
    { icon: Users, label: 'Leagues' },
    { icon: Trophy, label: 'Leaderboard' },
    { icon: TrendingUp, label: 'Market' },
    { icon: Clipboard, label: 'Game Plan'},
    { icon: BarChart2, label: 'Stats' },
    { icon: Settings, label: 'Settings' },
    { icon: HelpCircle, label: 'Help' },
  ];

  const toggleSidebar = () => setSidebarOpen(!sidebarOpen);

  const renderSidebar = () => (
    <nav className={`${isMobile ? 'fixed inset-y-0 left-0 z-50 w-64 transform transition-transform duration-200 ease-in-out' : 'w-64'} ${isMobile && !sidebarOpen ? '-translate-x-full' : 'translate-x-0'} bg-blue-800 p-6`}>
      <div className="flex justify-between items-center mb-8">
        <h1 className="text-2xl font-bold">Kick</h1>
        {isMobile && (
          <button onClick={toggleSidebar} className="text-white">
            <X size={24} />
          </button>
        )}
      </div>
      <ul>
        {menuItems.map((item) => (
          <li key={item.label} className="mb-4">
            <button
              className={`flex items-center w-full p-2 rounded-lg ${activeMenu === item.label.toLowerCase() ? 'bg-blue-600' : 'hover:bg-blue-700'}`}
              onClick={() => {
                setActiveMenu(item.label.toLowerCase());
                if (isMobile) setSidebarOpen(false);
              }}
            >
              <item.icon className="mr-3" size={20} />
              {item.label}
            </button>
          </li>
        ))}
      </ul>
    </nav>
  );

  const renderMobileNav = () => (
    <nav className="fixed bottom-0 left-0 right-0 bg-blue-800 flex justify-around items-center p-4 z-50">
      {menuItems.slice(0, 5).map((item) => (
        <button
          key={item.label}
          className={`flex flex-col items-center ${activeMenu === item.label.toLowerCase() ? 'text-blue-300' : 'text-white'}`}
          onClick={() => setActiveMenu(item.label.toLowerCase())}
        >
          <item.icon size={24} />
          <span className="text-xs mt-1">{item.label}</span>
        </button>
      ))}
    </nav>
  );

  return (
    <div className="flex min-h-screen bg-gradient-to-br from-blue-900 to-indigo-900 text-white">
      {!isMobile && renderSidebar()}
      
      <div className="flex-1 p-8 pb-20 md:pb-8">
        <header className="flex justify-between items-center mb-12">
          {isMobile && (
            <button onClick={toggleSidebar} className="text-white">
              <Menu size={24} />
            </button>
          )}
          <h2 className="text-3xl font-bold">{activeMenu.charAt(0).toUpperCase() + activeMenu.slice(1)}</h2>
          <button className="bg-yellow-500 text-black px-4 py-2 rounded-full flex items-center">
            <Wallet className="mr-2" size={20} />
            Connect Wallet
          </button>
        </header>

        <main>
          {activeMenu === 'home' && (
            <>
              <section className="mb-12">
                <h3 className="text-2xl font-semibold mb-4">Your Team Overview</h3>
                <div className="bg-white bg-opacity-10 p-6 rounded-lg">
                  <p className="text-xl mb-4">Team Value: 100 ETH</p>
                  <p className="text-xl mb-4">Total Points: 1,234</p>
                  <p className="text-xl mb-4">Gameweek Points: 78</p>
                  <button className="bg-green-500 text-white px-4 py-2 rounded">Manage Team</button>
                </div>
              </section>

              <section className="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
                <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
                  <Trophy className="mr-4" size={32} />
                  <div>
                    <h3 className="font-semibold">Leaderboard</h3>
                    <p>Your Rank: #42</p>
                  </div>
                </div>
                <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
                  <Users className="mr-4" size={32} />
                  <div>
                    <h3 className="font-semibold">Leagues</h3>
                    <p>5 Active Leagues</p>
                  </div>
                </div>
                <div className="bg-white bg-opacity-10 p-6 rounded-lg flex items-center">
                  <TrendingUp className="mr-4" size={32} />
                  <div>
                    <h3 className="font-semibold">Player Market</h3>
                    <p>238 Players Available</p>
                  </div>
                </div>
              </section>

              <section>
                <h3 className="text-2xl font-semibold mb-4">Upcoming Fixtures</h3>
                <div className="bg-white bg-opacity-10 p-6 rounded-lg">
                  <ul>
                    <li className="mb-2">Man City vs Liverpool - Sat, 15:00</li>
                    <li className="mb-2">Chelsea vs Arsenal - Sun, 14:00</li>
                    <li>Man United vs Tottenham - Sun, 16:30</li>
                  </ul>
                </div>
              </section>
            </>
          )}

            {activeMenu === 'leaderboard' && (
                <Leaderboard />
            )}

          {activeMenu === 'leagues' && (
                <League />
            )}

           {activeMenu === 'my team' && (
                <TeamManagement />
            )}

          {activeMenu === 'game plan' && (
                <GamePlan />
            )}

          {/* Add more content sections for other menu items */}
        </main>

        <footer className="mt-12 text-center text-sm opacity-70">
          © 2024 Kick. Powered by Lisk.
        </footer>
      </div>

      {isMobile && sidebarOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 z-40" onClick={toggleSidebar}></div>
      )}
      {isMobile && renderSidebar()}
      {isMobile && renderMobileNav()}
    </div>
  );
};

export default Home;