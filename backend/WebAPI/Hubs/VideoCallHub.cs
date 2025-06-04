using Microsoft.AspNetCore.SignalR;
using System.Threading.Tasks;

namespace WebAPI.Hubs
{
    public class VideoCallHub : Hub
    {

        //treba skontat gdje spremat sesije, dal inmemory, redis ili u bazi jer ce se brisat
        //mozda prvo kreirat inmemory zbog testiranja 
        
        
        public async Task StartCall(string userId, string roomId)
        {
        
            await Clients.Group(roomId).SendAsync("StartCall", userId);
        }
        public async Task JoinCall(string userId, string roomId)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, roomId);
            await Clients.Group(roomId).SendAsync("UserJoined", userId);
        }

        public async Task LeaveCall(string userId, string roomId)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, roomId);
            await Clients.Group(roomId).SendAsync("UserLeft", userId);
        }

        public async Task SendSignal(string userId, string roomId, object signal)
        {
            await Clients.Group(roomId).SendAsync("ReceiveSignal", userId, signal);
        }

      
    }
} 