import React, { useState } from 'react';
import { Users, Zap, Shield, TrendingUp, ChevronDown } from 'lucide-react';

type Formation = '4-4-2' | '4-3-3' | '3-5-2' | '5-3-2' | '4-2-3-1';
type AttackingStyle = 'Possession' | 'Counter-Attack' | 'High Press' | 'Wing Play' | 'Balanced';
type DefensiveStyle = 'High Line' | 'Low Block' | 'Man Marking' | 'Zonal Marking' | 'Balanced';
type Position = 'GK' | 'DEF' | 'MID' | 'FWD';

interface Player {
  id: number;
  name: string;
  position: Position;
  role: string;
}

interface PlayerRoles {
  [key: string]: string[];
}

const GamePlan: React.FC = () => {
  const [formation, setFormation] = useState<Formation>('4-4-2');
  const [attackingStyle, setAttackingStyle] = useState<AttackingStyle>('Balanced');
  const [defensiveStyle, setDefensiveStyle] = useState<DefensiveStyle>('Balanced');
  const [selectedPlayer, setSelectedPlayer] = useState<number | null>(null);

  const formations: Formation[] = ['4-4-2', '4-3-3', '3-5-2', '5-3-2', '4-2-3-1'];
  const attackingStyles: AttackingStyle[] = ['Possession', 'Counter-Attack', 'High Press', 'Wing Play', 'Balanced'];
  const defensiveStyles: DefensiveStyle[] = ['High Line', 'Low Block', 'Man Marking', 'Zonal Marking', 'Balanced'];

  const players: Player[] = [
    { id: 1, name: 'De Gea', position: 'GK', role: 'Goalkeeper' },
    { id: 2, name: 'Alexander-Arnold', position: 'DEF', role: 'Attacking Full-back' },
    { id: 3, name: 'Van Dijk', position: 'DEF', role: 'Ball-playing Defender' },
    { id: 4, name: 'Dias', position: 'DEF', role: 'Stopper' },
    { id: 5, name: 'Cancelo', position: 'DEF', role: 'Inverted Full-back' },
    { id: 6, name: 'De Bruyne', position: 'MID', role: 'Playmaker' },
    { id: 7, name: 'Kante', position: 'MID', role: 'Ball-winner' },
    { id: 8, name: 'Salah', position: 'MID', role: 'Inside Forward' },
    { id: 9, name: 'Son', position: 'MID', role: 'Winger' },
    { id: 10, name: 'Haaland', position: 'FWD', role: 'Target Man' },
    { id: 11, name: 'Kane', position: 'FWD', role: 'Deep-lying Forward' },
  ];

  const playerRoles: PlayerRoles = {
    GK: ['Sweeper Keeper', 'Traditional Goalkeeper'],
    DEF: ['Ball-playing Defender', 'Stopper', 'Attacking Full-back', 'Inverted Full-back'],
    MID: ['Deep-lying Playmaker', 'Box-to-box Midfielder', 'Attacking Midfielder', 'Winger', 'Inside Forward'],
    FWD: ['Target Man', 'Poacher', 'False Nine', 'Deep-lying Forward'],
  };

  const renderFormation = (): JSX.Element => {
    const [def, mid, fwd] = formation.split('-').map(Number);
    return (
      <div className="relative w-full h-96 bg-green-800 rounded-lg overflow-hidden mb-6">
        {/* Field markings */}
        <div className="absolute inset-0.5 border-2 border-white opacity-50 rounded-lg"></div>
        <div className="absolute top-1/2 left-0 right-0 h-0.5 bg-white opacity-50 transform -translate-y-1/2"></div>
        <div className="absolute top-[22%] left-0 right-0 h-0.5 bg-white opacity-50"></div>
        <div className="absolute bottom-[22%] left-0 right-0 h-0.5 bg-white opacity-50"></div>
        <div className="absolute top-1/2 left-1/2 w-32 h-32 border-2 border-white opacity-50 rounded-full transform -translate-x-1/2 -translate-y-1/2"></div>

        {/* Players */}
        <div className="absolute bottom-4 left-1/2 transform -translate-x-1/2">
          <div className="w-8 h-8 bg-red-500 rounded-full"></div>
        </div>
        {[...Array(def)].map((_, i) => (
          <div key={`def-${i}`} className="absolute bottom-1/4 transform -translate-x-1/2" style={{ left: `${(i + 1) * 100 / (def + 1)}%` }}>
            <div className="w-8 h-8 bg-slate-500 rounded-full"></div>
          </div>
        ))}
        {[...Array(mid)].map((_, i) => (
          <div key={`mid-${i}`} className="absolute bottom-1/2 transform -translate-x-1/2" style={{ left: `${(i + 1) * 100 / (mid + 1)}%` }}>
            <div className="w-8 h-8 bg-green-500 rounded-full"></div>
          </div>
        ))}
        {[...Array(fwd)].map((_, i) => (
          <div key={`fwd-${i}`} className="absolute bottom-3/4 transform -translate-x-1/2" style={{ left: `${(i + 1) * 100 / (fwd + 1)}%` }}>
            <div className="w-8 h-8 bg-yellow-500 rounded-full"></div>
          </div>
        ))}
      </div>
    );
  };

  return (
    <div className="bg-gradient-to-br from-slate-900 to-slate-900 text-white p-8 min-h-screen">
      <h1 className="text-3xl font-bold mb-8">Game Plan</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div>
          <h2 className="text-2xl font-semibold mb-4">Formation and Tactics</h2>
          <div className="mb-6">
            <label className="block mb-2">Formation</label>
            <select 
              className="w-full bg-slate-800 p-2 rounded"
              value={formation}
              onChange={(e) => setFormation(e.target.value as Formation)}
            >
              {formations.map(f => <option key={f} value={f}>{f}</option>)}
            </select>
          </div>
          
          {renderFormation()}

          <div className="grid grid-cols-2 gap-4 mb-6">
            <div>
              <label className="block mb-2">Attacking Style</label>
              <select 
                className="w-full bg-slate-800 p-2 rounded"
                value={attackingStyle}
                onChange={(e) => setAttackingStyle(e.target.value as AttackingStyle)}
              >
                {attackingStyles.map(style => <option key={style} value={style}>{style}</option>)}
              </select>
            </div>
            <div>
              <label className="block mb-2">Defensive Style</label>
              <select 
                className="w-full bg-slate-800 p-2 rounded"
                value={defensiveStyle}
                onChange={(e) => setDefensiveStyle(e.target.value as DefensiveStyle)}
              >
                {defensiveStyles.map(style => <option key={style} value={style}>{style}</option>)}
              </select>
            </div>
          </div>
        </div>

        <div>
          <h2 className="text-2xl font-semibold mb-4">Player Roles and Instructions</h2>
          <div className="bg-slate-800 p-4 rounded">
            {players.map(player => (
              <div key={player.id} className="mb-4 last:mb-0">
                <button
                  className="w-full text-left p-2 bg-slate-700 rounded flex justify-between items-center"
                  onClick={() => setSelectedPlayer(selectedPlayer === player.id ? null : player.id)}
                >
                  <span>{player.name} - {player.role}</span>
                  <ChevronDown className={`transform transition-transform ${selectedPlayer === player.id ? 'rotate-180' : ''}`} />
                </button>
                {selectedPlayer === player.id && (
                  <div className="mt-2 pl-4">
                    <div className="mb-2">
                      <label className="block mb-1">Role</label>
                      <select className="w-full bg-slate-600 p-2 rounded">
                        {playerRoles[player.position].map(role => (
                          <option key={role} value={role}>{role}</option>
                        ))}
                      </select>
                    </div>
                    <div>
                      <label className="block mb-1">Instructions</label>
                      <div className="space-y-2">
                        <label className="flex items-center">
                          <input type="checkbox" className="mr-2" /> Stay Back While Attacking
                        </label>
                        <label className="flex items-center">
                          <input type="checkbox" className="mr-2" /> Get Forward
                        </label>
                        <label className="flex items-center">
                          <input type="checkbox" className="mr-2" /> Cut Inside
                        </label>
                      </div>
                    </div>
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="mt-8 text-center">
        <button className="bg-green-500 text-white px-6 py-3 rounded-full text-lg font-semibold">
          Save Game Plan
        </button>
      </div>
    </div>
  );
};

export default GamePlan;