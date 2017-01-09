<?php

namespace App\Http\Controllers;

use App\Temps;
use App\User;
use App\Role;
use App\Permission;
use App\Rasp_Registration;
use Illuminate\Http\Request;


class HomeController extends Controller
{
    public function index(){
        return ("Dit is een test");
    }

    public function attachUserRole($userId, $role){
        $user = User::find($userId);

        $roleId = Role::where('name', $role)->first();

        $user->roles()->attach($roleId);

        return $user;
    }

    public function getUserRole($userId){
        return User::find($userId)->roles;
    }

    public function getPermissions($roleParam){
        $role = Role::where('name', $roleParam)->first();

        return $role->perms;
    }

    public function getTemps($date){
        $date_retrieved = Temps::where('created_at', $date)->get();
        return $date_retrieved;
    }

    public function getTempsMac($rasp_mac){
        $mac_retrieved = Temps::where('rasp_mac', $rasp_mac)->get();
        return $mac_retrieved;
    }

    public function checkMacRasp($mac_adres){
        $mac_retrieved = Rasp_Registration::where('mac_adres', $mac_adres)->get();
        return $mac_retrieved;
    }

    public function registerRasp($mac_rasp,$ip_rasp)
    {
        $temp = new Rasp_Registration();
        $temp->mac_adres       = $mac_rasp;
        $temp->ip_adres        = $ip_rasp;
        $temp->save();
    }

    public function showRegistered(){
        return User::all();
    }

    public function setTempsNew($temp_value, $air, $device_adres, $rasp_mac, $local_ip)
    {
        $temp = new Temps();
        $temp->temp            = $temp_value;
        $temp->air             = $air;
        $temp->device          = $device_adres;
        $temp->rasp_mac        = $rasp_mac;
        $temp->local_ip        = $local_ip;
        $temp->save();
    }

    public function getTempsAll(){
        return Temps::all()->last();
    }

    public function getTempsNow(){
        return Temps::all()->last();
    }

    public function attachPermission(Request $request){
        $parameters = $request->only('permission', 'role');

        $permissionParam = $parameters['permission'];
        $roleParam = $parameters['role'];

        $role = Role::where('name', $roleParam)->first();

        $permission = Permission::where('name', $permissionParam)->first();

        $role->attachPermission($permission);

        return $role->permissions;
    }

    public function getTempNow(){
        return Temps::all()->last();
    }
}
